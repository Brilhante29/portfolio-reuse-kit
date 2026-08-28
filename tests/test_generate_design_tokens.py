from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "generate_design_tokens", ROOT / "tools" / "generate-design-tokens.py"
)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class GenerateDesignTokensTests(unittest.TestCase):
    def test_renders_framework_neutral_web_primitives(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "tokens.yaml"
            source.write_text(
                """version: 2
colors: {ink: '#111827'}
spacing: {sm: '8px'}
radii: {panel: '6px'}
sizing: {icon_button: '38px'}
breakpoints: {mobile: '620px'}
shadows: {subtle: 'none'}
""",
                encoding="utf-8",
            )
            outputs = MODULE.render(source)
            css = outputs["tokens.css"].decode()
            scss = outputs["tokens.scss"].decode()

            self.assertIn("--portfolio-color-ink: #111827;", css)
            self.assertIn("--portfolio-space-sm: 8px;", css)
            self.assertIn("--portfolio-size-icon-button: 38px;", css)
            self.assertIn("$portfolio-breakpoint-mobile: 620px;", scss)
            self.assertIn("manifest.json", outputs)


if __name__ == "__main__":
    unittest.main()
