# Here are examples of optional variables with values. All variables already have reasonable defaults.
# This only an exmaple not a list of needed values.
resource_group_name = "[__resource_group_name__]"
aks_name            = "jstartaksdev08252021ab"

release_name               = "nginx-ingress-controller"
repository                 = "https://kubernetes.github.io/ingress-nginx"
chart_version              = "2.15.0"
timeout                    = 600
namespace_name             = "default"
ingress_class              = "nginx"
replica_count              = 2
autoscaling_enabled        = "true" # source showed this as a string rather than a bool. 
use_internal_load_balancer = true
create_namespace           = true