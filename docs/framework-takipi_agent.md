# Takipi Agent Framework
The Takipi Agent Framework causes an application to be automatically configured to work with Takipi SaaS.

## Configuration
For general information on configuring the buildpack, including how to specify configuration values through environment variables, refer to [Configuration and Extension][].

The framework can be configured by modifying the [`config/takipi_agent.yml`][] file in the buildpack fork.  The framework uses the [`Repository` utility support][repositories] and so it supports the [version syntax][] defined there.

| Name | Description
| ---- | -----------
| `version` | The version of Takipi to use. Currently only modifies displayed version.
| `node_name_prefix` | Node name prefix, will be concatenated with `-` and instance index to form the host name in Takipi.
| `uri` | The URI to download the Takipi agent tarball from |


The Takipi framework will be activated if the `secret_key` is set - this can be done by changing the value in `config/takipi_agent.yml` or by setting the environment variable `JBP_CONFIG_TAKIPI_AGENT` as explained in the configuration section.

## Logs

Currently, you can get the Takipi agent logs using `cf files` command:
```
cf files app_name app/.java-buildpack/takipi_agent/log/
```
