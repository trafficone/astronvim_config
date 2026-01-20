return {
  lazy = {
    -- Move the lockfile to a path that is always writable
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  },
}

