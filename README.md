# <WIP> orphans.nvim
To see which plugins are deprecated.

## Features
1. List all plugins ordered by the latest update time. 
2. Highlight plugins that are not maintained actively.
3. It's able to Ignore certain plugins.
4. Result can be cached.

## Approach
1. Iterate through all `rtp` directories one by one, check if it's a git repo, has either `lua/` or `plugin/`, then retrieve the latest git commit timestamp.
2. Filter out all plugin dirs and combine the meta info (date time, name, commit message, etc.)
3. Compose a list of all plugins and sort them lively while retrieving the info of the remaining plugins.
4. Display them on a floating window. Expand one item for more details.
5. Cache the result.

## TODOs
[ ] Cache results.
[ ] Export options for progress bar UI.
[ ] Fetch from origin automatically.
[ ] Ignore certain plugins.
[ ] Sort by name/commit time.
[ ] Floating window backdrop. https://github.com/folke/lazy.nvim/blob/main/lua/lazy/view/float.lua#L143
[ ] Auto resize. https://github.com/folke/lazy.nvim/blob/main/lua/lazy/view/float.lua#L190
