local M = {}

M.setup_tests = function(logger)
  local fns = {}

  fns.test = function(got, want)
    if got ~= want then
      logger.error(string.format("failed ❌, \ngot: %s \nwant %s", got, want))
      return
    end
    logger.info(string.format("passed ✅, \ngot: %s \nwant %s", got, want))
  end

  return fns
end

return M
