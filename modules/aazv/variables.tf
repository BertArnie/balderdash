variable "vpc_ids" {
  description = "List of vpc_id to authorize and associate"
  type        = list(string)
}

variable "zone_ids" {
  description = "List of Private hosted zone ID"
  type        = list(string)
}
