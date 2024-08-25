# Careful about copy/pasting, Makefiles want tabs!
# But you're not copy/pasting, are you?
.PHONY: update
update:
	home-manager switch --show-trace --flake .#chris

.PHONY: clean
clean:
	nix-collect-garbage -d
