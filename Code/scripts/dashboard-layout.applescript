-- dashboard-layout.applescript
-- Creates a 3-pane Ghostty layout for instant dashboard, with each pane
-- attached to a persistent zmx session:
--   default:  dashboard.code/nvim (left), dashboard.ai/claude (right-top), dashboard.dev/pnpm dev (right-bottom)
--   --left:   dashboard.ai (left-top), dashboard.dev (left-bottom), dashboard.code (right)
--
-- zmx attach is an upsert: if the session already exists (e.g. after closing
-- Ghostty) it reattaches with state restored and ignores the command; if not
-- (e.g. after a reboot) it creates the session running the command. So this
-- script is safe to re-run any time.
--
-- Prerequisites:
--   - Ghostty 1.3.0+
--   - zmx (brew install neurosnap/tap/zmx)
--   - macOS Accessibility permissions for Ghostty
--
-- Usage:
--   osascript ~/scripts/dashboard-layout.applescript
--   osascript ~/scripts/dashboard-layout.applescript --left

on run argv
	set leftMode to false
	repeat with arg in argv
		if (arg as string) is "--left" then set leftMode to true
	end repeat

	-- cd first so a newly created session inherits the right start dir;
	-- commands are spelled out (no shell aliases) because zmx spawns them
	-- directly; the compound dev command is wrapped in zsh -c
	set codeCmd to "cd ~/Code/instant/dashboard && zmx attach dashboard.code nvim"
	set aiCmd to "cd ~/Code/instant/dashboard && zmx attach dashboard.ai claude"
	set devCmd to "cd ~/Code/instant/dashboard && zmx attach dashboard.dev zsh -c 'pnpm i && pnpm dev'"

	tell application "Ghostty"
		activate
	end tell

	delay 0.5

	tell application "System Events"
		tell process "Ghostty"
			-- Rename tab to "dashboard" (Cmd+R = prompt_tab_title)
			keystroke "r" using {command down}
			delay 0.3
			keystroke "dashboard"
			key code 36 -- Enter
			delay 0.3

			if leftMode then
				-- Start in single pane. Split right -> focus moves to right pane (becomes neovim).
				keystroke "d" using {command down}
				delay 0.5

				-- In right pane: attach code session (nvim)
				keystroke codeCmd
				key code 36 -- Enter
				delay 0.3

				-- Goto left pane (Cmd+Option+Left)
				key code 123 using {command down, option down}
				delay 0.3

				-- Split down -> focus moves to left-bottom (dev server)
				keystroke "d" using {command down, shift down}
				delay 0.5

				-- In left-bottom pane: attach dev session (pnpm dev)
				keystroke devCmd
				key code 36 -- Enter
				delay 0.3

				-- Goto left-top pane (Cmd+Option+Up)
				key code 126 using {command down, option down}
				delay 0.3

				-- In left-top pane: attach ai session (claude)
				keystroke aiCmd
				key code 36 -- Enter
			else
				-- Default: stacked panes on the right.
				-- Split right to create right-top pane
				keystroke "d" using {command down}
				delay 0.5

				-- In right-top pane. Split down to create right-bottom pane.
				keystroke "d" using {command down, shift down}
				delay 0.5

				-- In right-bottom pane: attach dev session (pnpm dev)
				keystroke devCmd
				key code 36 -- Enter
				delay 0.3

				-- Goto right-top pane (Cmd+Option+Up)
				key code 126 using {command down, option down}
				delay 0.3

				-- In right-top pane: attach ai session (claude)
				keystroke aiCmd
				key code 36 -- Enter
				delay 0.3

				-- Goto left pane (Cmd+Option+Left)
				key code 123 using {command down, option down}
				delay 0.3

				-- In left pane: attach code session (nvim)
				keystroke codeCmd
				key code 36 -- Enter
			end if
		end tell
	end tell
end run
