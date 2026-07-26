# Continuity State

Generated: 2026-07-26T12:45:38.6637028-03:00
Purpose: mechanical Git and worktree state for continuation. Read CURRENT_HANDOFF.md for engineering decisions.

## reuse-kit-jvm-kafka

- Git repository: yes
- Repository alias: reuse-kit-jvm-kafka
- Branch: feat/jvm-kafka-governance
- Head: 529caa1666b850f98923160d66a7a60c3ca6e403
- Origin: https://github.com/Brilhante29/portfolio-reuse-kit.git
- Dirty entries at capture: 47

### Working Tree

    A  .claude/skills/continuity-checkpoint/SKILL.md
    A  .claude/skills/kafka-streams/SKILL.md
    A  .codex/skills/continuity-checkpoint/SKILL.md
    A  .codex/skills/kafka-streams/SKILL.md
    A  .portfolio-control/CONTINUITY_STATE.md
    M  .portfolio-control/CURRENT_HANDOFF.md
    M  .portfolio-control/EXECUTION_EFFICIENCY.md
    M  .portfolio-control/EXECUTION_EVENTS.jsonl
    A  AGENTS.md
    A  CLAUDE.md
    M  README.md
    A  contracts/fixtures/project.invalid.json
    A  contracts/fixtures/project.jvm-profile-missing-jvm.invalid.json
    A  contracts/fixtures/project.kafka-mode-mismatch.invalid.json
    A  contracts/fixtures/project.kafka-selected-brain-none.invalid.json
    A  contracts/fixtures/project.kafka-streams-orphan.invalid.json
    A  contracts/fixtures/project.legacy.valid.json
    A  contracts/fixtures/project.non-jvm.valid.json
    A  contracts/fixtures/project.unknown-wrapper-checksum.invalid.json
    A  contracts/fixtures/project.valid.json
    ... 27 additional entries omitted; run git status --short in this worktree.

### Recent Commits

    529caa1 fix: validate V2 project evidence efficiently
    68056a7 feat: add interoperable contract plane
    581631c Reject tracked build caches
    3c06254 Merge portfolio evidence decision layer
    cea7f9f Pin local cloud dependencies and diagnostics

### Worktrees

    worktree <local-worktree-1>
    HEAD 529caa1666b850f98923160d66a7a60c3ca6e403
    branch refs/heads/main
    worktree <local-worktree-2>
    HEAD 1520e81bae182a5bd4c8aa9b5a559fe351a99cc0
    detached
    worktree <local-worktree-3>
    HEAD 529caa1666b850f98923160d66a7a60c3ca6e403
    branch refs/heads/feat/jvm-kafka-governance
    worktree <local-worktree-4>
    HEAD 955d289fda1052698fd973f5ad426e646a319475
    branch refs/heads/fix/project-validator-v2

## kafka-wrapper-hardening-v2

- Git repository: yes
- Repository alias: kafka-wrapper-hardening-v2
- Branch: agent/gradle-wrapper-hardening-v2
- Head: ab9535a6f448c59b4452df440a45d7fbfbc77e31
- Origin: none
- Dirty entries at capture: 0

### Working Tree

- clean

### Recent Commits

    ab9535a feat(kafka): add benchmark and audited validation
    d7af1e9 chore: align project status with audited evidence
    be4cf50 chore: Update status to published
    158df64 feat: Implement portfolio requirements and benchmarks
    d20827a chore(kafka): normalize workflow whitespace

### Worktrees

    worktree <local-worktree-1>
    HEAD ab9535a6f448c59b4452df440a45d7fbfbc77e31
    branch refs/heads/agent/sync-agent-contract
    worktree <local-worktree-2>
    HEAD 57d101066de3fde416129017d5425f2215dbb708
    branch refs/heads/agent/gradle-wrapper-hardening
    worktree <local-worktree-3>
    HEAD ab9535a6f448c59b4452df440a45d7fbfbc77e31
    branch refs/heads/agent/gradle-wrapper-hardening-v2

## portfolio-evidence-api

- Git repository: yes
- Repository alias: portfolio-evidence-api
- Branch: main
- Head: 496df3e5a23b81b23f2182fea8998ff6c4b803ab
- Origin: https://github.com/Brilhante29/portfolio-evidence-api.git
- Dirty entries at capture: 1

### Working Tree

     M sdd/agent-handoff.md

### Recent Commits

    496df3e fix(ci): harden dependency audit transport
    c3567db docs: publish reproducible benchmark evidence
    14e43ef feat: implement portfolio evidence API
    4977409 Initial portfolio scaffold

### Worktrees

    worktree <local-worktree-1>
    HEAD 496df3e5a23b81b23f2182fea8998ff6c4b803ab
    branch refs/heads/main

## saga-kotlin

- Git repository: yes
- Repository alias: saga-kotlin
- Branch: agent/kotlin-saga-repair
- Head: 7414d932169ff2c9d1836dd5dca7ecdf8b0eb35b
- Origin: none
- Dirty entries at capture: 87

### Working Tree

     M .gitignore
     M .gradle/8.10.2/checksums/checksums.lock
     M .gradle/8.10.2/checksums/md5-checksums.bin
     M .gradle/8.10.2/checksums/sha1-checksums.bin
     M .gradle/8.10.2/dependencies-accessors/53481cfee09832239143e4342395b7903aaeb33b/metadata.bin
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$BundleAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$JacksonLibraryAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$JunitLibraryAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$PluginAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$SpringBootLibraryAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$SpringBootStarterLibraryAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$SpringDependencyPluginAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$SpringLibraryAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$SpringPluginAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$SpringVersionAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs$VersionAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibs.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibsInPluginsBlock$BundleAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibsInPluginsBlock$JacksonLibraryAccessors.class
     D .gradle/8.10.2/dependencies-accessors/de910d6249f4770ba9b7e4e96a85c66d99b6f2db/classes/org/gradle/accessors/dm/LibrariesForLibsInPluginsBlock$JunitLibraryAccessors.class
    ... 67 additional entries omitted; run git status --short in this worktree.

### Recent Commits

    7414d93 chore: align project status with audited evidence
    7a0dba2 chore: Update status to published
    dccd350 feat: Implement portfolio requirements and benchmarks
    e6766f0 Sync canonical project contract
    149b745 Standardize portfolio reuse contract

### Worktrees

    worktree <local-worktree-1>
    HEAD ae16726ba7b5b862310fc15d7f515f03ce2ea8e4
    branch refs/heads/agent/sync-agent-contract
    worktree <local-worktree-2>
    HEAD 7414d932169ff2c9d1836dd5dca7ecdf8b0eb35b
    branch refs/heads/agent/kotlin-saga-repair

## Next Actions

- Commit, push, open, and merge the JVM/Kafka governance pull request after green CI.
- Repair kafka-streams-demo with Wrapper, manifest v2, semantic tests, and split benchmarks.
- Do not update portfolio-evidence-api npm dependencies without the explicit public-registry authorization recorded in CURRENT_HANDOFF.md.
