# Development guide

The root [AGENTS.md](../AGENTS.md) and [CLAUDE.md](../CLAUDE.md) contain identical working instructions for agents. Keep all other documentation here.

## Documentation index

- [Computer-control tips](AGENT_EU5_COMPUTER_TIPS.md): verified workflows useful across unrelated features.
- [EU5 references](AGENT_EU5_RESOURCES.md): script/API reference starting points.
- [Local path example](AGENT_LOCAL_PATHS.example.md): copy to `docs/AGENT_LOCAL_PATHS.md` and adjust locally; the copy is gitignored.
- [Campaign setup and nation removal](AGENT_NATION_REMOVAL.md): behavior, implementation, historical test evidence, and limitations.
- [Player alliances](AGENT_PLAYER_ALLIANCES.md): two-human opinion exception, vanilla trigger replacement, synthetic coverage, and production checks.
- [Vision alliance](AGENT_VISION_ALLIANCE.md): consensual spectator pact, proxy coverage, and final production checks.

Document each future mod change here, including what changed and why, affected files, runtime test setup and evidence, and anything not verified. Historical tests describe what was actually done; they are not precedents overriding the current testing requirements.

## Git hooks

Run this from PowerShell once after cloning:

```powershell
./scripts/install-hooks.ps1
```

The installer sets this checkout's `core.hooksPath` to `.githooks`. Git does not enable tracked hooks automatically when cloning. The installer refuses to overwrite a different hook path; integrate this check into existing hooks if necessary. On Unix, also run `chmod +x .githooks/pre-commit` before using the hook.

The pre-commit hook compares the staged Git blobs for the two root instruction files. It rejects different contents, partial staging that leaves them different, or either file missing. It does not copy or stage files automatically. After editing the instructions, copy the content to the other file and stage both before committing. Like other local Git hooks, it can be bypassed with `--no-verify`; it is a local guard, not server-side enforcement.

Documentation and hook changes can be verified without launching EU5: check instruction-file equality, links, whitespace, and hook behavior in an isolated Git repository. Mod changes require the runtime testing specified in the root instructions.
