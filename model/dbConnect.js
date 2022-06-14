const { Pool, Client } = require('pg');

const pool = new Pool();

module.exports = pool;


// max_connections = 200
// shared_buffers = 2GB
// effective_cache_size = 6GB
// maintenance_work_mem = 512MB
// checkpoint_completion_target = 0.9
// wal_buffers = 16MB
// default_statistics_target = 100
// random_page_cost = 1.1
// effective_io_concurrency = 200
// work_mem = 2621kB
// min_wal_size = 1GB
// max_wal_size = 4GB
// max_worker_processes = 8
// max_parallel_workers_per_gather = 4
// max_parallel_workers = 8
// max_parallel_maintenance_workers = 4


// client = 1 connection to db

// pool set of clients
/*
  driver has its own set of options to interat with psql
  pool
 */