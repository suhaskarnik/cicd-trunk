resource "aws_lambda_function" "this" {
  function_name = "lambda-${var.env_name}"
  handler = "app.handler"
  runtime = "nodejs18.x"  # Choose the desired Node.js runtime

  # This is the part that sets the default AWS Node.js code
  source_code_hash = var.archive_file.output_base64sha256
  filename = var.archive_file.output_path

  role = aws_iam_role.lambda_exec_role.arn

  tags = merge({},
    var.tags
  
  )
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role-${var.env_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = merge({},
    var.tags
  
  )
}