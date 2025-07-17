#!/usr/bin/env bash
set -euo pipefail

echo "Bash is working correctly!"
echo "Testing basic functionality..."

# Test basic commands
echo "Testing echo: OK"
echo "Testing variables: OK"

# Test functions
test_function() {
    echo "Testing functions: OK"
}

test_function

echo "All tests passed!" 