#include "erl_nif.h"
#include "crypt3.c"

static ERL_NIF_TERM crypt3(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  if (argc != 2) {
    return enif_make_badarg(env);
  }

  ErlNifBinary pw;
  ErlNifBinary salt;

  enif_inspect_binary(env, argv[0], &pw);
  enif_inspect_binary(env, argv[1], &salt);

  ErlNifBinary result;
  enif_alloc_binary(13, &result);

  char* r = crypt((char *)pw.data, (char *)salt.data);
  
  int i = 0;
  for (i = 0; i < 13; i++) {
    result.data[i] = r[i];
  }

  return enif_make_binary(env, &result);
}

static ErlNifFunc nif_funcs[] = {
  {"crypt", 2, crypt3, 0}
};

ERL_NIF_INIT(Elixir.Crypt3, nif_funcs, NULL, NULL, NULL, NULL)