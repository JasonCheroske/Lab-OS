output "queue_url" {
  value       = "${azurerm_servicebus_namespace.this.name}.servicebus.windows.net/${azurerm_servicebus_queue.dlq_source.name}"
  description = "Service Bus queue endpoint (inject as TASK_QUEUE_URL)."
}

output "queue_arn" {
  value       = azurerm_servicebus_queue.dlq_source.id
  description = "Service Bus queue ARM resource ID."
}

output "dlq_url" {
  value       = "${azurerm_servicebus_namespace.this.name}.servicebus.windows.net/${azurerm_servicebus_queue.dlq_source.name}/$DeadLetterQueue"
  description = "Dead-letter sub-queue path."
}

output "dlq_arn" {
  value       = "${azurerm_servicebus_queue.dlq_source.id}/$DeadLetterQueue"
  description = "Dead-letter sub-queue pseudo-ARN (ARM ID + suffix)."
}
