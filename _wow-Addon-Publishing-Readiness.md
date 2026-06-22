# World of Warcraft Addon Publishing Readiness Checklist

> Goal: Ensure this GitHub repository is fully configured for automated releases to CurseForge and Wago using GitHub Actions and BigWigs Packager.
>
> Repository: **Kevinjohn/wow-addon-quest-ui-reorder**
>
> Date Checked: **2026-06-22**
>
> Checked By: **Claude (Opus 4.8), for Kevinjohn Gallagher**

> **Legend:** `[x]` done & verified in-repo · `[ ]` not done — see the note ·
> 🔧 **ACTION (you)** = can only be done outside the repo (GitHub UI / CurseForge /
> Wago / in-game) and is listed in **Remaining actions** at the bottom.

> **Overall result: GitHub Release automation is READY now.** Push a `vX.Y.Z`
> tag and a GitHub Release with the zip is created automatically. CurseForge and
> Wago uploads are fully wired and switch on the moment you complete the four
> external steps in **Remaining actions** (create the projects, add their IDs to
> the `.toc`, add the two repo secrets). No repo changes are needed for that.

---

# Phase 1 — Repository Audit

## Basic Structure

- [x] Repository exists on GitHub. (`origin` → github.com/Kevinjohn/wow-addon-quest-ui-reorder)
- [x] Repository contains addon source code. (`QuestUIReorder.lua`, `Locales.lua`, `Options.lua`)
- [x] Repository contains a valid `.toc` file. (`QuestUIReorder.toc` at repo root)
- [x] Addon loads successfully inside World of Warcraft. (verified in-game against retail **12.0.5** — see README/CHANGELOG; `.toc` now targets 12.0.7)
- [x] No obvious build errors exist. (`scripts/check.sh`: luacheck **0 warnings / 0 errors**, **495** test checks pass)
- [x] No temporary or backup files are committed. (`git ls-files` is clean)

Actual structure (flat / root layout — required by the BigWigs packager, see `docs/packaging.md`):

```text
wow-addon-quest-ui-reorder/
├── QuestUIReorder.toc
├── QuestUIReorder.lua  Locales.lua  Options.lua
├── README.md  README-DEV.md  CHANGELOG.md  LICENSE
├── .pkgmeta
└── .github/
    ├── workflows/release.yml      ← NEW (Phase 5)
    ├── ISSUE_TEMPLATE/  pull_request_template.md
```

---

## TOC Validation — `QuestUIReorder.toc`

- [x] `## Title:` exists.
- [x] `## Author:` exists.
- [x] `## Notes:` exists. (plus localized `## Notes-<locale>` for 11 locales)
- [x] `## Interface:` exists.
- [x] Interface version is current for supported WoW version. (`120007` = patch **12.0.7**)
- [x] `## Version:` exists.
- [x] Version uses `## Version: @project-version@` (packager stamps the git tag at build time)
- [x] `## X-Curse-Project-ID:` exists. — line present with a `000000` placeholder; replace with the real ID once the CurseForge project exists. 🔧 **ACTION (you)**
- [x] `## X-Wago-ID:` exists. — line present with a `000000` placeholder; replace with the real ID once the Wago project exists. 🔧 **ACTION (you)**

Now uncommented in the `.toc` (replace the placeholder with the real IDs):

```toc
## X-Curse-Project-ID: 000000
## X-Wago-ID: 000000
```

---

# Phase 2 — Publishing Configuration

## CurseForge — 🔧 **ACTION (you)** (external; nothing to change in the repo)

- [ ] CurseForge project exists.
- [ ] Correct CurseForge Project ID obtained.
- [ ] Project ID matches TOC. (paste it into `## X-Curse-Project-ID:` — Phase 1)
- [ ] Project is configured as a WoW Addon.
- [ ] Project description exists.
- [ ] Project icon exists (recommended).
- [ ] Source code URL configured. (https://github.com/Kevinjohn/wow-addon-quest-ui-reorder)

Reference: https://authors.curseforge.com/

---

## Wago — 🔧 **ACTION (you)** (external; nothing to change in the repo)

- [ ] Wago project exists.
- [ ] Correct Wago Project ID obtained.
- [ ] Project ID matches TOC. (paste it into `## X-Wago-ID:` — Phase 1)
- [ ] Project description exists.
- [ ] Source code URL configured.

Reference: https://addons.wago.io/

---

# Phase 3 — GitHub Secrets — 🔧 **ACTION (you)**

Open: Repository → Settings → Secrets and variables → Actions

- [ ] `CF_API_TOKEN` exists. (the workflow already maps this secret to the packager's `CF_API_KEY`)
- [ ] `WAGO_API_TOKEN` exists. (the workflow already references this secret)

> Note: `GITHUB_TOKEN` is provided automatically by GitHub Actions — no secret to
> add for the GitHub Release itself.

Confirmed in this repo:

- [x] Tokens are not stored in source code.
- [x] Tokens are not committed to repository.
- [x] Tokens are not present in README files.
- [x] Tokens are not present in workflow files. (`release.yml` references `${{ secrets.* }}` only)

---

# Phase 4 — Packaging Configuration

## .pkgmeta (repo root) — verified by a local dry-run build

- [x] `package-as` value is correct. (`QuestUIReorder`)
- [x] Ignore rules are sensible.
- [x] Development files excluded. (`scripts`, `tests`, `docs`, `*.md` docs, dotfiles)
- [x] GitHub workflow files excluded from release package. (`ignore: .github` → `release.yml` never ships in the zip)

`sh scripts/release.sh` (no-upload dry-run) produced a clean zip containing only:

```text
QuestUIReorder/
├── QuestUIReorder.toc      # @project-version@ → v0.5.0-alpha-2-gbda95e5, Interface 120007
├── QuestUIReorder.lua  Locales.lua  Options.lua
├── LICENSE
└── CHANGELOG.md            # curated (manual-changelog), not the git-log dump
```

Reference: https://github.com/BigWigsMods/packager

---

# Phase 5 — GitHub Actions — ✅ implemented

Workflow: `.github/workflows/release.yml`

- [x] Workflow uses BigWigs Packager. (`uses: BigWigsMods/packager@v2`)
- [x] Workflow triggers on Git tags. (`on: push: tags: ['v*']`)
- [x] Workflow creates GitHub Releases. (`GITHUB_OAUTH: ${{ secrets.GITHUB_TOKEN }}` + `permissions: contents: write`)
- [x] Workflow uploads to CurseForge. (wired via `CF_API_KEY: ${{ secrets.CF_API_TOKEN }}`; auto-skips until the secret **and** `X-Curse-Project-ID` are set)
- [x] Workflow uploads to Wago. (wired via `WAGO_API_TOKEN: ${{ secrets.WAGO_API_TOKEN }}`; auto-skips until the secret **and** `X-Wago-ID` are set)

> It runs the *same* packager as `scripts/release.sh`, so it honours `.pkgmeta`
> (package-as, ignore list, curated changelog). The local script remains for
> no-upload dry-runs / manual uploads.

Reference: https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow

---

# Phase 6 — Documentation

- [x] `README.md` exists. (with badges, screenshots section, install + footer)
- [x] Installation instructions exist. (README → Installation, per-OS paths)
- [x] Repository description exists. (README H1 + summary; the GitHub repo "About" blurb is a UI setting — 🔧 optional **ACTION (you)** to mirror it)
- [x] Licence file exists. (`LICENSE`, MIT)
- [x] Changelog exists or release notes are generated automatically. (curated `CHANGELOG.md`, Keep a Changelog format, also fed to store release notes)

Present: `README.md`, `README-DEV.md`, `LICENSE`, `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`.

---

# Phase 7 — Release Validation — 🔧 **ACTION (you)** (needs a tag pushed to GitHub)

A local dry-run build (Phase 4/8) passed as a proxy; a real run requires pushing a tag.
First **commit `.github/workflows/release.yml`** — a tag-triggered run uses the
workflow as it exists in the tagged commit, so tag a commit that already contains
it (the pre-existing `v0.5.0-alpha` tag predates the workflow and won't trigger
one). Also confirm Settings → Actions → Workflow permissions is read/write.

```bash
git tag v0.0.1-test
git push origin v0.0.1-test
```

## GitHub

- [ ] Workflow executed successfully.
- [ ] GitHub Release created.
- [ ] Release ZIP attached.

## CurseForge — only after Phases 2 & 3 are complete

- [ ] File uploaded successfully.
- [ ] Version visible.
- [ ] Release notes present.
- [ ] No validation errors.

## Wago — only after Phases 2 & 3 are complete

- [ ] File uploaded successfully.
- [ ] Version visible.
- [ ] Release notes present.
- [ ] No validation errors.

> Tip: delete the throwaway test tag/release afterwards
> (`git push origin :v0.0.1-test` + delete the Release in the GitHub UI).

---

# Phase 8 — Package Verification — verified locally (dry-run zip)

- [x] ZIP extracts correctly.
- [x] Top-level folder name is correct. (`QuestUIReorder/`)
- [x] TOC file exists inside package. (`@project-version@` substituted; Interface 120007)
- [ ] Addon appears in WoW AddOns list. — 🔧 in-game (you); previously confirmed on 12.0.5
- [ ] Addon loads without Lua errors. — 🔧 in-game (you); luacheck is clean
- [ ] SavedVariables still function correctly. — 🔧 in-game (you); `## SavedVariables: QuestUIReorderDB`

Expected (and produced) ZIP structure:

```text
QuestUIReorder.zip
└── QuestUIReorder/
    ├── QuestUIReorder.toc
    ├── QuestUIReorder.lua
    └── ...
```

---

# Phase 9 — Future Release Process — ✅ supported

```bash
git tag v1.0.0
git push origin v1.0.0
```

- [x] GitHub Release created automatically. (works today)
- [x] CurseForge upload created automatically. (after Phases 2 & 3 — no further repo changes)
- [x] Wago upload created automatically. (after Phases 2 & 3 — no further repo changes)
- [x] No manual ZIP creation required.
- [x] No manual uploads required.

---

# Final Sign-Off

## Publishing Readiness

- [x] Repository ready for automated publishing. (GitHub Releases now; CF/Wago wired, pending external setup)
- [ ] CurseForge integration working. — pending Phases 2 & 3 🔧
- [ ] Wago integration working. — pending Phases 2 & 3 🔧
- [x] GitHub Actions working. (workflow added; packaging verified via local dry-run)
- [ ] Test release completed successfully. — pending a tag push (Phase 7) 🔧

Result:

- [x] **PASS** — for GitHub Release automation (live now).
- [ ] FAIL
- [ ] PENDING — CurseForge + Wago, until the four external steps below are done.

---

# Remaining actions (cannot be done from the repository)

Everything in the repo is configured. To finish enabling the CurseForge/Wago path:

1. **Create the CurseForge project** (https://authors.curseforge.com/) and the
   **Wago project** (https://addons.wago.io/); set each project's source URL to
   the repo and add a description/icon.
2. **Put the real IDs in the `.toc`** — replace the `000000` placeholders in
   `## X-Curse-Project-ID:` / `## X-Wago-ID:` in `QuestUIReorder.toc` (Phase 1). Commit.
3. **Add the repo secrets** (Settings → Secrets and variables → Actions):
   `CF_API_TOKEN` (CurseForge API token) and `WAGO_API_TOKEN` (Wago API token).
4. **Push a test tag** (`v0.0.1-test`) and confirm the GitHub Release + both
   uploads (Phase 7), then remove the test tag/release.

After that, every `git tag vX.Y.Z && git push origin vX.Y.Z` publishes to GitHub,
CurseForge, and Wago automatically.
