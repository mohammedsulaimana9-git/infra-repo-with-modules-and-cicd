module "iam" {
  source    = "./modules/iam"
  role_name = var.role_name
}

module "ec2" {
  source            = "./modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  instance_name     = var.instance_name
  key_name          = var.key_name
  iam_instance_role = module.iam.role_name
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "lambda" {
  source               = "./modules/lambda"
  function_name        = var.lambda_function_name
  lambda_role_arn      = module.iam.lambda_role_arn
}