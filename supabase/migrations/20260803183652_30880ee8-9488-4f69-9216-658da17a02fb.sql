CREATE POLICY "Usuários autenticados podem apagar pacientes" ON public.pacientes FOR DELETE TO authenticated USING (true);
GRANT DELETE ON public.pacientes TO authenticated;