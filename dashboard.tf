resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.name
  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/SQS",
            "ApproximateNumberOfMessagesVisible",
            "QueueName",
            "${aws_sqs_queue.main.name}",
            {
              "region": "${var.region}"
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": true,
        "region": "${var.region}",
        "period": 1,
        "title": "Messages Queued",
        "stat": "Maximum"
      }
    },
    {
      "type": "metric",
      "x": 6,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/SQS",
            "ApproximateNumberOfMessagesNotVisible",
            "QueueName",
            "${aws_sqs_queue.main.name}",
            {
              "region": "${var.region}",
              "color": "#2ca02c"
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": true,
        "region": "${var.region}",
        "period": 1,
        "stat": "Maximum",
        "title": "Messages Processing"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "ECS/ContainerInsights",
            "DesiredTaskCount",
            "ServiceName",
            "${module.ecs_service.name}",
            "ClusterName",
            "${module.ecs_cluster.name}",
            {
              "region": "${var.region}"
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": true,
        "region": "${var.region}",
        "title": "Workers Desired",
        "period": 1,
        "stat": "Maximum"
      }
    },
    {
      "type": "metric",
      "x": 6,
      "y": 6,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/ECS",
            "CPUUtilization",
            "ServiceName",
            "${module.ecs_service.name}",
            "ClusterName",
            "${module.ecs_cluster.name}",
            {
              "region": "${var.region}"
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": true,
        "region": "${var.region}",
        "period": 1,
        "stat": "Maximum",
        "yAxis": {
          "left": {
            "label": "",
            "min": 0,
            "max": 100
          }
        }
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/ECS",
            "MemoryUtilization",
            "ServiceName",
            "${module.ecs_service.name}",
            "ClusterName",
            "${module.ecs_cluster.name}",
            {
              "color": "#ff7f0e",
              "region": "${var.region}"
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": true,
        "region": "${var.region}",
        "stat": "Maximum",
        "period": 1,
        "setPeriodToTimeRange": true,
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100
          }
        }
      }
    },
    {
      "type": "metric",
      "x": 18,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "ECS/ContainerInsights",
            "RunningTaskCount",
            "ServiceName",
            "${module.ecs_service.name}",
            "ClusterName",
            "${module.ecs_cluster.name}",
            {
              "region": "${var.region}",
              "color": "#2ca02c"
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": true,
        "region": "${var.region}",
        "title": "Workers Running",
        "period": 1,
        "stat": "Maximum"
      }
    }
  ]
}
EOF
}
