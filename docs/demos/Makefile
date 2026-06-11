.PHONY: all clean chezmoi helix terminal ai-flow

TAPES := chezmoi.tape helix.tape workspace.tape helix-claude.tape
GIFS  := $(TAPES:.tape=.gif)

all: $(GIFS)

%.gif: %.tape
	vhs $<

chezmoi:      chezmoi.gif
helix:        helix.gif
workspace:    workspace.gif
helix-claude: helix-claude.gif

clean:
	rm -f *.gif
