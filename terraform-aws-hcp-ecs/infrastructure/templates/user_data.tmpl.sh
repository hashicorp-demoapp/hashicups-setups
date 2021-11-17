#!/bin/bash

cat <<'EOF' >> /etc/ecs/ecs.config
ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true
ECS_ENABLE_TASK_ENI=true
ECS_CLUSTER=${cluster_name}
EOF