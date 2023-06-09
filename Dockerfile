ARG grafana_version=latest
ARG grafana_image=grafana-oss

FROM ubuntu:latest as root
ARG deep_datasource_version=0.0.3
ARG deep_panel_version=0.0.3

RUN apt update && apt install unzip
ADD https://github.com/intergral/grafana-deep-datasource/releases/download/v${deep_datasource_version}/intergral-deep-datasource-${deep_datasource_version}.zip /opt/deep/plugins/intergral-deep-datasource.zip
ADD https://github.com/intergral/grafana-deep-panel/releases/download/v${deep_panel_version}/intergral-deep-panel-${deep_panel_version}.zip /opt/deep/plugins/intergral-deep-panel.zip

RUN mkdir -p /var/lib/grafana/plugins
RUN unzip /opt/deep/plugins/intergral-deep-datasource.zip -d /var/lib/grafana/plugins/intergral-deep-datasource
RUN unzip /opt/deep/plugins/intergral-deep-panel.zip -d /var/lib/grafana/plugins/intergral-deep-panel


FROM grafana/${grafana_image}:${grafana_version}-ubuntu
USER grafana

COPY --from=root /var/lib/grafana/plugins/intergral-deep-datasource/intergral-deep-datasource /var/lib/grafana/plugins/intergral-deep-datasource
COPY --from=root /var/lib/grafana/plugins/intergral-deep-panel/intergral-deep-panel /var/lib/grafana/plugins/intergral-deep-panel