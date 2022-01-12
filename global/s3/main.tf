provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "arms3" 
 
  # sa nra hamar a, vor ete destroy tanq, s3 baketn chjnjvi
  
  lifecycle {
    prevent_destroy = true
  }

  #sa nra hamar a, vor ete baketi exacn tarmana nor versiai, hnaravor exni nayel #hin versianern u anhrajeshtutyan depqum andradarnal dranc

  versioning {
    enabled = true
  }

#sa nra hamar a, vor gaxtni tvyalnern u anhrajesht amen inch shifrovka exni S3um

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

 # dynamo db sarqenq blokirovka anelu hamar LockID banaliov

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "ArmS3_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
 
  attribute {
    name = "LockID"
    type = "S"
  }
}
  
terraform {
  backend "s3" {
    bucket       = "arms3"
    key          = "global/s3/terraform.tfstate"
    region       = "us-east-1"
    dynamodb_table = "ArmS3_lock"
    encrypt      = true
  }
}

