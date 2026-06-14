from redis.cluster import RedisCluster
import hashlib

rc = RedisCluster(
    host="10.10.0.11",
    port=6379,
    decode_responses=True
)

success = 0

for i in range(1, 1001):
    key = f"key:{i:04d}"

    value = hashlib.sha256(
        key.encode()
    ).hexdigest()

    rc.set(key, value)

    success += 1

print(f"Inserted {success} keys successfully")
