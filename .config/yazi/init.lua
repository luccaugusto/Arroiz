function Linemode:size_and_mtime()
	local year = os.date("%Y")
	local time = math.floor(self._file.cha.mtime or 0)

	if time > 0 and os.date("%Y", time) == year then
		time = os.date("%b %d %H:%M", time)
	else
		time = time and os.date("%b %d  %Y", time) or ""
	end

	local size = self._file:size()
	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or "-", time))
end

require("augment-command"):setup({
    default_item_group_for_prompt = "selected",
    enter_directory_after_creation = true,
	smart_enter = true,
	smart_paste = true,
    smooth_scrolling = true,
    wraparound_file_navigation = true,
	enter_archives = false,
})
