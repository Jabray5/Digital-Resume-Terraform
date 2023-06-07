// Create a variable for our domain name because we'll be using it a lot.
variable "www_domain_name" {
  default = "www.jbrayshaw.co.uk"
}

// We'll also need the root domain (also known as zone apex or naked domain).
variable "root_domain_name" {
  default = "jbrayshaw.co.uk"
}