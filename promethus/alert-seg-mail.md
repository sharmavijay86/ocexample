global:
  resolve_timeout: 5m
route:
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 12h
  receiver: default
  routes:
  - match:
      alertname: DeadMansSwitch
    repeat_interval: 5m
    receiver: deadmansswitch
  - match:
      severity: critical
    receiver: itops
receivers:
- name: default
  email_configs:
    - send_resolved: true
      # Whether or not to notify about resolved alerts.
      # The email address to send notifications to.
      to:  vfqa_appmonitoring@vodafone.com,Rakesh.Carpenter@Vodafone.com,Rahul.Chaudhari@Vodafone.com,Imtiyaz.Hasan@Vodafone.com,Anshu.Kumar2@Vodafone.com,Binata.Nayak@Vodafone.com,Johnson.Niti@Vodafone.com,Mehul.Patel10@Vodafone.com,Kiran.Rakhunde@Vodafone.com,pankaj.sharma1@vodafone.com,vijay.vishwakarma3@vodafone.com,Sandip.Yadav@Vodafone.com
      # The sender address.
      from: ocpalert@vodafone.com.qa
      # The SMTP host through which emails are sent.
      smarthost: 10.100.205.162:25
      # The hostname to identify to the SMTP server.
      hello: prometheus-k8s-openshift-monitoring.infra.cn.vq.internal.vodafone.com
      # The SMTP TLS requirement.
      require_tls: false
- name: itops
  email_configs:
    - send_resolved: true
      # Whether or not to notify about resolved alerts.
      # The email address to send notifications to.
      to: DL-ITOperations@vodafone.com
      # The sender address.
      from: ocpalert@vodafone.com.qa
      # The SMTP host through which emails are sent.
      smarthost: 10.100.205.162:25
      # The hostname to identify to the SMTP server.
      hello: prometheus-k8s-openshift-monitoring.infra.cn.vq.internal.vodafone.com
      # The SMTP TLS requirement.
      require_tls: false
- name: deadmansswitch
