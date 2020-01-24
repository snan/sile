-- Info nodes are used to store information about what actually ends up on which page.
-- Index terms are an obvious use for this, as well as anything where you wanted to
-- know where something had ended up after the page builder had broken the page.
-- Check out SILE.scratch.info.thispage in your end-of-page routine and see what nodes
-- are there.

-- Exports
--    newPageInfo (call this in endPage to empty the info node list)
SILE.scratch.info = {
  thispage = {}
}

local _info = pl.class({
    _base = SILE.nodefactory.hbox,
    type ="special",
    category = "",
    value = nil,
    width = SILE.length(),

    __tostring = function (self) return "I<" .. self.category .. "|" .. self.value.. ">"; end,

    outputYourself = function (self, _, _)
      if not SILE.scratch.info.thispage[self.category] then
        SILE.scratch.info.thispage[self.category] = {self.value}
      else
        local i = #(SILE.scratch.info.thispage[self.category]) + 1
        SILE.scratch.info.thispage[self.category][i] = self.value
      end
    end

  })

SILE.registerCommand("info", function (options, _)
  SU.required(options, "category", "info node")
  SU.required(options, "value", "info node")
  table.insert(SILE.typesetter.state.nodes, _info({
        category = options.category,
        value = options.value
    }))
end, "Inserts an info node onto the current page")

return {
  init = function () end,
  exports = {
    newPageInfo = function ()
      SILE.scratch.info = { thispage = {} }
    end
  }
}
