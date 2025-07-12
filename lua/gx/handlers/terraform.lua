local helper = require("gx.helper")

---@type GxHandler
local M = {
  -- every filetype and filename
  name = "terraform",
  filetype = { "hcl", "terraform" },
  filename = nil,
}

-- Table of supported Terraform providers with their pattern prefix and URL provider name
local providers = {
  { prefix = "aws_", provider = "aws" },
  { prefix = "azurerm_", provider = "azurerm" },
  { prefix = "google_", provider = "google" },
  { prefix = "kubernetes_", provider = "kubernetes" },
}

local function match_terraform_resource(line, kind, prefix)
  local pattern = string.format('%s "%s([^"]*)"', kind, prefix)
  return helper.find(line, nil, pattern)
end

function M.handle(_, line, _)
  local base_url = "https://registry.terraform.io/providers/hashicorp/%s/latest/docs"

  -- Check each provider in our table
  for _, provider in ipairs(providers) do
    local resource = match_terraform_resource(line, "resource", provider.prefix)
    if resource then
      return base_url:format(provider.provider) .. "/resources/" .. resource
    end

    resource = match_terraform_resource(line, "data", provider.prefix)
    if resource then
      return base_url:format(provider.provider) .. "/data-sources/" .. resource
    end
  end
end

return M
