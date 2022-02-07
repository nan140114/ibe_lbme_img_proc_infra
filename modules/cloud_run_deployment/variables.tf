terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

variable env {
    type = string
}

variable project_id {
    type = string
}

variable containers {
    type = list(object({
        name       = string,
        version    = string,
        repository = string, 
        env        = list(object({
            name  = optional(string),
            value = optional(string)
        }))
    }))

}

variable location {
    type = string
    description = "location to deploy resources"
}

variable public_repo {
    type = bool
    description = "location to deploy resources"
    default = false
}

variable region {
    type = string
    default = "us-central1"
}