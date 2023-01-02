resource "aws_s3_bucket" "site" {
  bucket = "${var.domain}"
  acl = "public-read"

  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Id": "Policy1663162260738",
        "Statement": [
            {
                "Sid": "Stmt1663162256001",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${var.domain}/*"
            }
        ]
    }

  EOF

  website {
      index_document = "index.html"
      error_document = "404.html"
  }
    tags = {
    "Name" = "Site"
  }
}
