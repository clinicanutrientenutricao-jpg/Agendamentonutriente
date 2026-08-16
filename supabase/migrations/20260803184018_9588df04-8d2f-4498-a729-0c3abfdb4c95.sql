-- Roles infrastructure
DO $$ BEGIN
  CREATE TYPE public.app_role AS ENUM ('admin', 'user');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS public.user_roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role public.app_role NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, role)
);

GRANT SELECT ON public.user_roles TO authenticated;
GRANT ALL ON public.user_roles TO service_role;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own roles" ON public.user_roles;
CREATE POLICY "Users can view their own roles" ON public.user_roles
FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role public.app_role)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role
  )
$$;

REVOKE ALL ON FUNCTION public.has_role(uuid, public.app_role) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) TO authenticated, service_role;

-- Existing users become admins (staff-only app)
INSERT INTO public.user_roles (user_id, role)
SELECT id, 'admin'::public.app_role FROM auth.users
ON CONFLICT (user_id, role) DO NOTHING;

-- Lock down trigger functions
REVOKE ALL ON FUNCTION public.handle_new_user() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.handle_updated_at() FROM PUBLIC, anon, authenticated;

-- agendamentos_consulta
DROP POLICY IF EXISTS "Usuários autenticados podem visualizar todos os agendamentos" ON public.agendamentos_consulta;
DROP POLICY IF EXISTS "Usuários autenticados podem apagar agendamentos de consulta" ON public.agendamentos_consulta;
CREATE POLICY "Ver próprios agendamentos ou admin" ON public.agendamentos_consulta
FOR SELECT TO authenticated USING (auth.uid() = user_id OR public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Apagar próprios agendamentos ou admin" ON public.agendamentos_consulta
FOR DELETE TO authenticated USING (auth.uid() = user_id OR public.has_role(auth.uid(), 'admin'));

-- agendamentos_retorno
DROP POLICY IF EXISTS "Usuários autenticados podem visualizar todos os retornos" ON public.agendamentos_retorno;
CREATE POLICY "Ver próprios retornos ou admin" ON public.agendamentos_retorno
FOR SELECT TO authenticated USING (auth.uid() = user_id OR public.has_role(auth.uid(), 'admin'));

-- audios_enviados
DROP POLICY IF EXISTS "Usuários autenticados podem visualizar todos os áudios" ON public.audios_enviados;
CREATE POLICY "Ver próprios áudios ou admin" ON public.audios_enviados
FOR SELECT TO authenticated USING (auth.uid() = user_id OR public.has_role(auth.uid(), 'admin'));

-- pacientes
DROP POLICY IF EXISTS "Allow public read access to pacientes" ON public.pacientes;
DROP POLICY IF EXISTS "Allow public insert access to pacientes" ON public.pacientes;
DROP POLICY IF EXISTS "Usuários autenticados podem apagar pacientes" ON public.pacientes;
REVOKE ALL ON public.pacientes FROM anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.pacientes TO authenticated;
GRANT ALL ON public.pacientes TO service_role;
CREATE POLICY "Usuários logados podem ver pacientes" ON public.pacientes
FOR SELECT TO authenticated USING (true);
CREATE POLICY "Usuários logados podem cadastrar pacientes" ON public.pacientes
FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Usuários logados podem atualizar pacientes" ON public.pacientes
FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Admins podem apagar pacientes" ON public.pacientes
FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'));

-- configs
DROP POLICY IF EXISTS "Allow public read access to configs" ON public.configs;
DROP POLICY IF EXISTS "Allow public write access to configs" ON public.configs;
REVOKE ALL ON public.configs FROM anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.configs TO authenticated;
GRANT ALL ON public.configs TO service_role;
CREATE POLICY "Usuários logados podem ler configs" ON public.configs
FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admins podem gerenciar configs" ON public.configs
FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- webhooks
DROP POLICY IF EXISTS "Allow public read access to webhooks" ON public.webhooks;
DROP POLICY IF EXISTS "Allow public write access to webhooks" ON public.webhooks;
REVOKE ALL ON public.webhooks FROM anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.webhooks TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE public.webhooks_id_seq TO authenticated;
GRANT ALL ON public.webhooks TO service_role;
CREATE POLICY "Usuários logados podem ler webhooks" ON public.webhooks
FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admins podem gerenciar webhooks" ON public.webhooks
FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));