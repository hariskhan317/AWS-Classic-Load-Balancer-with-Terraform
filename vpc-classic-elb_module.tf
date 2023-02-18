module "elb_module" {
    source  = "terraform-aws-modules/elb/aws"
    version = "~> 2.0"

    name = "elb-example"

    subnets         = [ module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
    security_groups = [module.sg_elb.security_group_id]
    internal        = false

    listener = [
    {
        instance_port     = 80
        instance_protocol = "HTTP"
        lb_port           = 80
        lb_protocol       = "HTTP"
    },
    {
        instance_port     = 8080
        instance_protocol = "http"
        lb_port           = 81
        lb_protocol       = "http" 
    },
    ]

    health_check = {
        target              = "HTTP:80/"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
    }

    // ELB attachments
    number_of_instances = var.private_instance_count
    instances           = [for instance in module.ec2_instance_private: instance.id]

    tags = {
        Owner       = "user"
        Environment = "dev"
    }
}