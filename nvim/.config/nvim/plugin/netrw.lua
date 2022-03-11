-- #############################################################################
-- NetRW Options
-- #############################################################################

vim.g.netrw_browse_split = 0              -- open in same window
vim.g.netrw_banner = 0                    -- disable annoying banner
vim.g.netrw_altv = 1                      -- open splits to the right
vim.g.netrw_winsize = 50                  -- when pressing v/t have the new split be 50% of the whole screen
vim.g.newrw_localrmdir = "rm -r"          -- This variable is only used if your vim is earlier than 7.4 or if your vim doesn't have patch#1107.  Otherwise, |delete()| is used with the 'd' option.
