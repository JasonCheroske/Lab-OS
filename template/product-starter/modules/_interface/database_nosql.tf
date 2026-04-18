# Interface: database_nosql
# See database/_variants.md and ADR-TR-008 for semantic divergence notes.
variable "table_name"   { type = string }
variable "team"         { type = string }
variable "environment"  { type = string }
variable "owner"        { type = string; default = "" }
variable "tags"         { type = map(string); default = {} }
