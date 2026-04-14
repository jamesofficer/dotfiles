-- dev-layout.applescript
-- Creates a 3-pane Ghostty layout: neovim (left), claude (right-top), pnpm start (right-bottom)
--
-- Prerequisites:
--   - Ghostty 1.3.0+
--   - macOS Accessibility permissions for Ghostty
--
-- Usage: osascript ~/scripts/dev-layout.applescript

tell application "Ghostty"
	activate
end tell

delay 0.5

tell application "System Events"
	tell process "Ghostty"
		-- We start in the left pane (will become neovim)

		-- Split right to create right-top pane
		keystroke "d" using {command down}
		delay 0.5

		-- We're now in the right-top pane. Split down to create right-bottom pane.
		keystroke "d" using {command down, shift down}
		delay 0.5

		-- We're now in the right-bottom pane. cd and run pnpm start:sim
		keystroke "cd ~/Code/logro/packages/app && pnpm run start:sim"
		key code 36 -- Enter
		delay 0.3

		-- Navigate to right-top pane (Cmd+Option+Up = goto_split:up)
		key code 126 using {command down, option down}
		delay 0.3

		-- We're now in right-top pane. cd and run claude
		keystroke "cd ~/Code/logro && claude"
		key code 36 -- Enter
		delay 0.3

		-- Navigate to left pane (Cmd+Option+Left = goto_split:left)
		key code 123 using {command down, option down}
		delay 0.3

		-- We're now in the left pane. cd and run neovim
		keystroke "cd ~/Code/logro && nv"
		key code 36 -- Enter
	end tell
end tell
