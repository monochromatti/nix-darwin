{ ... }:
{
  flake.modules.homeManager.aliases = {
    home.shellAliases = {
      lg = "lazygit";
      zed = "zeditor .";
      agentenv = "nix shell github:numtide/llm-agents.nix#amp github:numtide/llm-agents.nix#tuicr github:fornybar/pydeptree";
    };
  };
}
