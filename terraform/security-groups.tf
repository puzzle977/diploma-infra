# -----------------------------------
# Security Groups
# -----------------------------------

# ---------------------------
# Bastion
# ---------------------------
resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "SSH from Internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# ALB (если используешь SG для ALB)
# ---------------------------
resource "yandex_vpc_security_group" "alb_sg" {
  name       = "alb-sg"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP from Internet to ALB"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# Web servers (web1/web2)
# ---------------------------
resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg"
  network_id = yandex_vpc_network.vpc.id

  # HTTP на web — ТОЛЬКО от ALB
  ingress {
    protocol          = "TCP"
    description       = "HTTP from ALB"
    security_group_id = yandex_vpc_security_group.alb_sg.id
    port              = 80
  }

  # SSH на web — только с bastion (по SG)
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion_sg.id
    port              = 22
  }

  # Zabbix agent (ВАЖНО: чтобы zabbix-server мог опрашивать web)
  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent from private network"
    v4_cidr_blocks = ["10.0.0.0/8"]
    port           = 10050
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# Zabbix server VM
# ---------------------------
resource "yandex_vpc_security_group" "zabbix_sg" {
  name       = "zabbix-sg"
  network_id = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "Zabbix web UI"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent (optional)"
    v4_cidr_blocks = ["10.0.0.0/8"]
    port           = 10050
  }

  ingress {
    protocol       = "TCP"
    description    = "Zabbix server"
    v4_cidr_blocks = ["10.0.0.0/8"]
    port           = 10051
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion_sg.id
    port              = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# Elasticsearch VM
# ---------------------------
resource "yandex_vpc_security_group" "elastic_sg" {
  name       = "elastic-sg"
  network_id = yandex_vpc_network.vpc.id

  # Elasticsearch из внутренней сети (filebeat/kibana)
  ingress {
    protocol       = "TCP"
    description    = "Elasticsearch from private network"
    v4_cidr_blocks = ["10.0.0.0/8"]
    port           = 9200
  }

  # SSH только с bastion
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion_sg.id
    port              = 22
  }

  # Zabbix agent (чтобы zabbix-server мог опрашивать elastic)
  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent from private network"
    v4_cidr_blocks = ["10.0.0.0/8"]
    port           = 10050
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# Kibana VM
# ---------------------------
resource "yandex_vpc_security_group" "kibana_sg" {
  name       = "kibana-sg"
  network_id = yandex_vpc_network.vpc.id

  # Kibana UI (ты открываешь публично)
  ingress {
    protocol       = "TCP"
    description    = "Kibana web UI"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  # SSH только с bastion
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    security_group_id = yandex_vpc_security_group.bastion_sg.id
    port              = 22
  }

  # Zabbix agent (чтобы zabbix-server мог опрашивать kibana)
  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent from private network"
    v4_cidr_blocks = ["10.0.0.0/8"]
    port           = 10050
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
