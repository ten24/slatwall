#!/bin/bash

version='testtag'

git tag -a $(version) -m "Version $version"
git push origin $(version)