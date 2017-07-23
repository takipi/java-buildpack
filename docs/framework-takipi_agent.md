# Takipi Agent Framework
The Takipi Agent Framework causes an application to be automatically configured to work with OverOps (www.overops.com).

## Configuration
For general information on configuring the buildpack, including how to specify configuration values through environment variables, refer to [Configuration and Extension][].

The framework can be configured by modifying the [`config/takipi_agent.yml`][] file. The framework uses the [`Repository` utility support][repositories] and so it supports the [version syntax][] defined there.

| Name | Description
| ---- | -----------
| `node_name_prefix` | Node name prefix, will be concatenated with `-` and instance index to form the host name in Takipi.
| `secret_key` | Installation key to use with SaaS (Optional)
| `collector_host` | Remote collector hostname (or ip) to use (Optional)
| `collector_port` | Remote collector port to use (Optional)

The Takipi framework will be activated if either `secret_key` or `collector_host` is set - this can be done by changing the value in `config/takipi_agent.yml` or by setting the environment variable `JBP_CONFIG_TAKIPI_AGENT` as explained in the configuration section.

## Logs

Currently, you can get the Takipi agent logs using `cf files` command:
```
cf files app_name app/.java-buildpack/takipi_agent/log/
```

[OverOps Remote Collector]: https://support.overops.com/hc/en-us/articles/227109628-Remote-Daemon-Process-
[OverOps Service]: https://www.overops.com
