# ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) GCP Cloud Bucket

This Terraform module creates a Google Cloud Storage bucket with public access configuration.

## Features

- Creates a GCS bucket with public read access
- Configurable website hosting
- CORS configuration support
- Lifecycle rules management
- Versioning support

## Usage

```hcl
module "public_bucket" {
  source = "./modules/gcs-public-bucket"

  project_id  = "your-project-id"
  bucket_name = "your-bucket-name"
  
  website_config = {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  
  cors_rules = [{
    origin          = ["https://yourdomain.com"]
    method          = ["GET", "HEAD", "OPTIONS"]
    response_header = ["*"]
    max_age_seconds = 3600
  }]
}
```

## Requirements

- Terraform >= 1.0
- Google Provider >= 4.0

## Providers

| Name   | Version |
| ------ | ------- |
| google | >= 4.0  |

## Inputs

| Name              | Description                                                                   | Type           | Default      | Required |
| ----------------- | ----------------------------------------------------------------------------- | -------------- | ------------ | :------: |
| project_id        | The ID of the project to create the bucket in                                 | `string`       | n/a          |   yes    |
| bucket_name       | The name of the bucket                                                        | `string`       | n/a          |   yes    |
| location          | The location of the bucket                                                    | `string`       | `"US"`       |    no    |
| storage_class     | The Storage Class of the new bucket                                           | `string`       | `"STANDARD"` |    no    |
| force_destroy     | When deleting a bucket, this boolean option will delete all contained objects | `bool`         | `false`      |    no    |
| enable_versioning | Enable versioning for the bucket                                              | `bool`         | `false`      |    no    |
| website_config    | Website configuration for the bucket                                          | `object`       | `null`       |    no    |
| cors_rules        | CORS configuration for the bucket                                             | `list(object)` | `[]`         |    no    |
| lifecycle_rules   | The bucket's Lifecycle Rules configuration                                    | `list(object)` | `[]`         |    no    |

## Outputs

| Name              | Description                |
| ----------------- | -------------------------- |
| bucket            | The created storage bucket |
| bucket_name       | Bucket name                |
| bucket_url        | Bucket URL                 |
| public_access_url | Public access URL          |

## Notes

- The bucket is configured with public read access by default
- Uniform bucket-level access is disabled to allow fine-grained permissions
- Default object ACL is set to public read

## License

[MIT](./LICENSE)
