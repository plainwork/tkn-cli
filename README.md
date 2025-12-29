# Taken CLI

A tiny Bash CLI that appends your clipboard to Markdown notebooks.

## Usage

- `tkn` to append to the default notebook if set (otherwise prompts to select)
- `tkn <name>` to append to a specific notebook
- `tkn --select` (or `-s`) to force notebook selection
- `tkn add <name>` to create a notebook
- `tkn remove <name>` to delete a notebook
- `tkn search <query>` to search notebooks for a phrase (includes date context)
- `tkn open <name>` to open a notebook in a simple TUI
- `tkn edit <name>` to edit a notebook in your `$EDITOR` (prompts and saves a default in `~/.config/taken/editor` if unset)
- `tkn default <name>` to set the default notebook (save to `~/.config/taken/default_notebook`)
- `tkn default --clear` to unset the default notebook
- `tkn sync <remote>` to sync notebooks with a git repo (stores remote and keeps in sync)
- `tkn config dir <path>` to set the notebooks directory (prints current if omitted)
- `tkn config editor <cmd>` to set the editor (prints current if omitted)
- `tkn config wrap <wrap|nowrap>` to set preview wrapping (prints current if omitted)
- `tkn config reset` to clear saved dir/editor/git settings
- Notebook names cannot match built-in command names (e.g. `add`, `search`, `open`)
- `tkn today` to show notebooks with notes from today
- `tkn yesterday` to show notebooks with notes from yesterday
- `tkn last week` to show notebooks with notes from the last 7 days
- `tkn last month` to show notebooks with notes from the last 30 days
- `tkn between <m1> <m2> [year]` to show notes between months (e.g. `tkn between jun aug 2024`)
- `tkn on <YYYY-MM-DD>` to show notebooks with notes on a date

Notebooks live in `~/.taken/notebooks` by default. Override with `TAKEN_DIR`.

## Optional dependency

If `fzf` is installed, `tkn` uses it for fast interactive notebook selection.
It is also used to filter search results and preview notebooks in `tkn open`.

## Sync behavior

`tkn sync` pulls with rebase + autostash, commits local changes, then pushes.

## Homebrew

This repo includes a Homebrew formula. From a tap:

```bash
brew tap mark/taken https://github.com/mark/taken-cli
brew install taken
```

If you're testing locally:

```bash
brew install --formula ./Formula/taken.rb
```
