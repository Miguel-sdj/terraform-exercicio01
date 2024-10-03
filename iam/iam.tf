resource "aws_iam_user" "mcc2_nvc" {
  name = "mcc2_nvc"
}

resource "aws_iam_group" "power_user_group" {
  name = "power_user_group"
}

resource "aws_iam_user_group_membership" "my_iam_user_group_membership" {
  user = aws_iam_user.mcc2_nvc.name
  groups = [aws_iam_group.power_user_group.name,]
}

resource "aws_iam_policy_attachment" "poweruser_attach" {
  name       = "poweruser-attach"
  groups     = [aws_iam_group.power_user_group.name]
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}