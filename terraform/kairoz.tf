resource "template_file" "kairoz_containers" {
    template = "${file("container-definitions/kairoz.json.tmpl")}"

    vars {
        version = "${var.image_version}"
        appenv = "${format("kairozenv-%s-us-west-2", var.environment)}"
        syslog_address = "${var.syslog_address}"
        syslog_tag = "${format("kairoz-%s", var.image_version)}"
    }
}

resource "aws_ecs_task_definition" "kairoz" {
    family = "kairoz"
    container_definitions = "${template_file.kairoz_containers.rendered}"
}

resource "aws_ecs_service" "kairoz" {
    name = "${format("kairoz-%s", var.environment)}"
    cluster = "${var.ecs_cluster}"
    task_definition = "${aws_ecs_task_definition.kairoz.arn}"
    desired_count = 2
    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100
    iam_role = "${var.ecs_iam_role}"

    load_balancer {
        elb_name = "kairoz"
        container_name = "kairoz"
        container_port = 9113
    }
}
