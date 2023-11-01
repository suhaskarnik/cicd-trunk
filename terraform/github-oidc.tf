resource "aws_iam_role" "github_actions_role" {
  name = "github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRoleWithWebIdentity",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = var.oidc_audience
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.repository_name}:environment:dev"
          }
        }
      }]
  })

  tags = merge({},
    local.tags
  
  )
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}

data "aws_iam_policy_document" "github_actions_policy" {
  statement {
    actions   = [
          "lambda:CreateFunction",
				  "lambda:PublishLayerVersion",
          "lambda:PublishVersion",
          "lambda:UpdateFunctionCode"
        ]
    resources = [
          for module_key, module_instance in module.lambda : module_instance.lambda_arn
        ]
    effect = "Allow"
  }
  
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "github-actions-cicd-lambda"
  path        = "/"
  description = "Policy allowing GitHub Actions to perform CI-CD on specified Lambda functions"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = data.aws_iam_policy_document.github_actions_policy.json
}




resource "aws_iam_role_policy_attachment" "attach" {
  policy_arn = aws_iam_policy.github_actions_policy.arn
  role = aws_iam_role.github_actions_role.name
}