# lazyjj.nvim

An integration of [lazyjj](https://github.com/Cretezy/lazyjj) in nvim

### Installation

##### Lazy

(Only tested thought [Lazyvim](https://github.com/LazyVim/LazyVim))

```lua
{
  "Glhou/lazyjj.nvim",
  config = function()
    require("lazyjj").setup()
  end,
}
```
```
```


### Configuration

```lua
local lazyjj = require("lazyjj")
lazyjj.setup({
  keymap = "<leader>jj" -- default keymap
})
```


```
```
