# == Class: druid::indexing::overlord
#
# Setup a Druid node runing the indexing overlord service.
#
# === Parameters
#
# [*host*]
#   Host address the service listens on.
#
#   Default value: The `$ipaddress` fact.
#
# [*port*]
#   Port the service listens on.
#
#   Default value: `8090`.
#
# [*service*]
#   The name of the service.
#
#   This is used as a dimension when emitting metrics and alerts.  It is
#   used to differentiate between the various services
#
#   Default value: `'druid/overlord'`.
#
# [*autoscale*]
#   Enable autoscaling.
#
#   Valid values: `true` or `false`.
#
#   Default value: `false`.
#
# [*autoscale_max_scaling_duration*]
#   Time to wait for a middle manager to appear before giving up.
#
#   Default value: `'PT15M'`.
#
# [*autoscale_num_events_to_track*]
#   The number of autoscaling events to track.
#
#   This includes node creation and termination.
#
#   Default value: `10`.
#
# [*autoscale_origin_time*]
#   Starting time stamp the terminate period increments upon.
#
#   Default value: `'2012-01-01T00:55:00.000Z'`.
#
# [*autoscale_pending_task_timeout*]
#   Time a task can be "pending" before scaling up.
#
#   Default value: `'PT30S'`.
#
# [*autoscale_provision_period*]
#   Time window to check if new middle managers should be added.
#
#   Default value: `'PT1M'`.
#
# [*autoscale_strategy*]
#   Strategy to run when autoscaling is required.
#
#   Valid values: `'noop'` or `'ec2'`.
#
#   Default value: `'noop'`.
#
# [*autoscale_terminate_period*]
#   Time window to check if middle managers should be removed.
#
#   Default value: `'PT5M'`.
#
# [*autoscale_worker_idle_timeout*]
#   Idle time of a worker before it is considered for termination.
#
#   Default value: `'PT90M'`.
#
# [*autoscale_worker_port*]
#   Port that middle managers will listen on.
#
#   Default value: `8080`.
#
# [*autoscale_worker_version*]
#   Node versions to create.
#
#   If set, the overlord will only create nodes of set version during
#   autoscaling. This overrides dynamic configuration.
#
# [*jvm_opts*]
#   Array of options to set for the JVM running the service.
#
#   Default value: [
#     '-server',
#     '-Duser.timezone=UTC',
#     '-Dfile.encoding=UTF-8',
#     '-Djava.io.tmpdir=/tmp',
#     '-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager'
#   ]
#
# [*queue_max_size*]
#   Maximum number of active tasks at one time.
#
# [*queue_restart_delay*]
#   Sleep time when queue management throws an exception.
#
#   Default value: `'PT30S'`.
#
# [*queue_start_delay*]
#   Sleep time before starting overlord queue management.
#
#   This can be useful to give a cluster time to re-orient itself (e.g.
#   after a widespread network issue).
#
#   Default value: `'PT1M'`.
#
# [*queue_storage_sync_rate*]
#   Rate to sync state with an underlying task persistence mechanism.
#
#   Default value: `'PT1M'`.
#
# [*runner_compress_znodes*]
#   Expect middle managers to compress Znodes.
#
#   Valid values: `true` or `false`.
#
#   Default value: `true`.
#
# [*runner_max_znode_bytes*]
#   Maximum Znode size in bytes that can be created in Zookeeper.
#
#   Default value: `524288`.
#
# [*runner_min_worker_version*]
#   Minimum middle manager version to send tasks to.
#
#   Default value: `'0'`.
#
# [*runner_task_assignment_timeout*]
#   Time to wait after a task has been assigned to a middle manager.
#
#   Tasks that take longer then this results in an error being thrown.
#
#   Default value: `'PT5M'`.
#
# [*runner_task_cleanup_timeout*]
#   Time to wait before failing a task when the middle manager assigned the
#   task becomes disconnected from Zookeeper.
#
#   Default value: `'PT15M'`.
#
# [*runner_type*]
#   Specify if tasks are run locally or in a distributed environment.
#
#   Valid values: `'local'` or `'remote'`.
#
#   Default value: `'local'`.
#
# [*storage_recently_finished_threshold*]
#   Time to store task results.
#
#   Default value: `'PT24H'`.
#
# [*storage_type*]
#   Specify where incoming task are stored.
#
#   Storing incoming tasks in metadata storage allows for tasks to be
#   resumed if the overlord should fail.
#
#   Valid values:
#     * `'local'`: In heap
#     * `'metadata'`: Metadata storage.
#
#   Default value: `'local'`.
#
# === Authors
#
# Tyler Yahn <codingalias@gmail.com>
#

class druid::indexing::overlord (
  $host                                = $druid::params::overlord_host,
  $port                                = $druid::params::overlord_port,
  $service                             = $druid::params::overlord_service,
  $autoscale                           = $druid::params::overlord_autoscale,
  $autoscale_max_scaling_duration      = $druid::params::overlord_autoscale_max_scaling_duration,
  $autoscale_num_events_to_track       = $druid::params::overlord_autoscale_num_events_to_track,
  $autoscale_origin_time               = $druid::params::overlord_autoscale_origin_time,
  $autoscale_pending_task_timeout      = $druid::params::overlord_autoscale_pending_task_timeout,
  $autoscale_provision_period          = $druid::params::overlord_autoscale_provision_period,
  $autoscale_strategy                  = $druid::params::overlord_autoscale_strategy,
  $autoscale_terminate_period          = $druid::params::overlord_autoscale_terminate_period,
  $autoscale_worker_idle_timeout       = $druid::params::overlord_autoscale_worker_idle_timeout,
  $autoscale_worker_port               = $druid::params::overlord_autoscale_worker_port,
  $autoscale_worker_version            = $druid::params::overlord_autoscale_worker_version,
  $jvm_opts                            = $druid::params::overlord_jvm_opts,
  $queue_max_size                      = $druid::params::overlord_queue_max_size,
  $queue_restart_delay                 = $druid::params::overlord_queue_restart_delay,
  $queue_start_delay                   = $druid::params::overlord_queue_start_delay,
  $queue_storage_sync_rate             = $druid::params::overlord_queue_storage_sync_rate,
  $runner_compress_znodes              = $druid::params::overlord_runner_compress_znodes,
  $runner_max_znode_bytes              = $druid::params::overlord_runner_max_znode_bytes,
  $runner_min_worker_version           = $druid::params::overlord_runner_min_worker_version,
  $runner_task_assignment_timeout      = $druid::params::overlord_runner_task_assignment_timeout,
  $runner_task_cleanup_timeout         = $druid::params::overlord_runner_task_cleanup_timeout,
  $runner_type                         = $druid::params::overlord_runner_type,
  $storage_recently_finished_threshold = $druid::params::overlord_storage_recently_finished_threshold,
  $storage_type                        = $druid::params::overlord_storage_type,
) inherits druid::params {
  require druid

  validate_string(
    $host,
    $service,
    $autoscale_max_scaling_duration,
    $autoscale_origin_time,
    $autoscale_pending_task_timeout,
    $autoscale_provision_period,
    $autoscale_strategy,
    $autoscale_terminate_period,
    $autoscale_worker_idle_timeout,
    $autoscale_worker_version,
    $queue_restart_delay,
    $queue_start_delay,
    $queue_storage_sync_rate,
    $runner_min_worker_version,
    $runner_task_assignment_timeout,
    $runner_task_cleanup_timeout,
    $runner_type,
    $storage_recently_finished_threshold,
    $storage_type,
  )

  validate_integer($port)
  validate_integer($autoscale_num_events_to_track)
  validate_integer($autoscale_worker_port)
  validate_integer($runner_max_znode_bytes)
  if $queue_max_size {
    validate_integer($queue_max_size)
  }

  validate_bool(
    $autoscale,
    $runner_compress_znodes,
  )

  validate_array($jvm_opts)

  druid::service { 'overlord':
    config_content  => template("${module_name}/overlord.runtime.properties.erb"),
    service_content => template("${module_name}/druid-overlord.service.erb"),
  }
}
