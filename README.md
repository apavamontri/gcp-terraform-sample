# Terraform to setup Google Cloud Platform (GCP) for ZRS project

## Terraform

Allow you to create, update, delete infrastructure using code. For more information please visit [Terraform][0] website.

### Install Terraform on macOS

Use `homebrew`. For installation instruction please visit [Homebrew][1] website.

```
brew install terraform
```

### Google Cloud Provider

We will be using Google Cloud provider to interact with Google Cloud Services.

1. Create _Service Account_ and save the JSON file as `xxx.json`
2. Copy to `root` of terraform directory
3. Add `*.json` to `.gitignore` file

[0]: https://www.terraform.io/
[1]: https://brew.sh/
