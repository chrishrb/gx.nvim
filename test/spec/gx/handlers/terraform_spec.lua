local handler = require("gx.handlers.terraform")

describe("terraform_handler", function()
  it("aws resources", function()
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance",
      handler.handle("v", 'resource "aws_instance" "example" {')
    )
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket",
      handler.handle("v", 'resource "aws_s3_bucket" "my_bucket" {')
    )
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function",
      handler.handle("v", '  resource "aws_lambda_function" "test_lambda" {')
    )
  end)

  it("azure resources", function()
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group",
      handler.handle("v", 'resource "azurerm_resource_group" "example" {')
    )
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine",
      handler.handle("v", 'resource "azurerm_virtual_machine" "main" {')
    )
  end)

  it("google resources", function()
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance",
      handler.handle("v", 'resource "google_compute_instance" "default" {')
    )
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket",
      handler.handle("v", 'resource "google_storage_bucket" "static" {')
    )
  end)

  it("kubernetes resources", function()
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment",
      handler.handle("v", 'resource "kubernetes_deployment" "example" {')
    )
    assert.equals(
      "https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service",
      handler.handle("v", 'resource "kubernetes_service" "example" {')
    )
  end)

  it("non-terraform lines", function()
    assert.is_nil(handler.handle("v", "This is not a terraform resource"))
    assert.is_nil(handler.handle("v", 'variable "example" {'))
    assert.is_nil(handler.handle("v", 'data "aws_ami" "example" {'))
    assert.is_nil(handler.handle("v", 'resource "unknown_provider_resource" "example" {'))
  end)
end)
