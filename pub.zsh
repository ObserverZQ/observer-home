#!/bin/zsh
hugo
cd public
git add -A && git commit -m 'new article' && git push
cd ../
git add -A && git commit -m 'new article' && git push