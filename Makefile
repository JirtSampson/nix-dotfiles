# Careful about copy/pasting, Makefiles want tabs!
# But you're not copy/pasting, are you?
.PHONY: update
update:
	home-manager switch --impure --flake .#chris

.PHONY: clean
clean:
	nix-collect-garbage -d
