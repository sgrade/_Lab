#!/usr/bin/env bash

# 193. Valid Phone Numbers
# https://leetcode.com/problems/valid-phone-numbers/

grep -E '^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$|^[0-9]{3}-[0-9]{3}-[0-9]{4}$' valid-phone-numbers.txt
