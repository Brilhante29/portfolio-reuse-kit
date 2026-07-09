# Publish

Use this when the kit is ready to publish.

## Expected GitHub Repository

```txt
Brilhante29/portfolio-reuse-kit
```

## If The Remote Repo Already Exists

```powershell
git remote add origin https://github.com/Brilhante29/portfolio-reuse-kit.git
git add .
git commit -m "Polish portfolio reuse kit"
git push -u origin main
```

## If The Remote Repo Does Not Exist

Create an empty public repository named `portfolio-reuse-kit` under `Brilhante29`, then run:

```powershell
git remote add origin https://github.com/Brilhante29/portfolio-reuse-kit.git
git add .
git commit -m "Polish portfolio reuse kit"
git push -u origin main
```

## Validation Before Push

```powershell
powershell -ExecutionPolicy Bypass -File tools/validate-kit.ps1
python harness/bench.py --project kit-smoke --metric latency_ms --unit ms --repeat 1 --warmup 0 --out-dir benchmarks/results python --version
```

The benchmark JSON under `benchmarks/results/` is intentionally ignored by Git.