#!/bin/bash

cd $(dirname $0)
fd -g '*.[ch]' src | gtags -vi --sqlite3 -f -
