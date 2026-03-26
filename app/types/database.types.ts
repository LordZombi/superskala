export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.4"
  }
  public: {
    Tables: {
      areas: {
        Row: {
          description: string | null
          id: string
          name: string
        }
        Insert: {
          description?: string | null
          id?: string
          name: string
        }
        Update: {
          description?: string | null
          id?: string
          name?: string
        }
        Relationships: []
      }
      boulders: {
        Row: {
          description: string | null
          id: string
          image_url: string | null
          lat: number | null
          lon: number | null
          name: string
          sector_id: string
        }
        Insert: {
          description?: string | null
          id?: string
          image_url?: string | null
          lat?: number | null
          lon?: number | null
          name: string
          sector_id: string
        }
        Update: {
          description?: string | null
          id?: string
          image_url?: string | null
          lat?: number | null
          lon?: number | null
          name?: string
          sector_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "boulders_sector_id_fkey"
            columns: ["sector_id"]
            isOneToOne: false
            referencedRelation: "sectors"
            referencedColumns: ["id"]
          },
        ]
      }
      climbs: {
        Row: {
          boulder_id: string
          climbing_style: string | null
          description: string | null
          grade: string | null
          grade_id: number | null
          id: string
          is_dangerous: boolean | null
          is_project: boolean
          is_sit_start: boolean | null
          name: string
          start_x: number | null
          start_y: number | null
          top_x: number | null
          top_y: number | null
          topo_path: string | null
        }
        Insert: {
          boulder_id: string
          climbing_style?: string | null
          description?: string | null
          grade?: string | null
          grade_id?: number | null
          id?: string
          is_dangerous?: boolean | null
          is_project?: boolean
          is_sit_start?: boolean | null
          name: string
          start_x?: number | null
          start_y?: number | null
          top_x?: number | null
          top_y?: number | null
          topo_path?: string | null
        }
        Update: {
          boulder_id?: string
          climbing_style?: string | null
          description?: string | null
          grade?: string | null
          grade_id?: number | null
          id?: string
          is_dangerous?: boolean | null
          is_project?: boolean
          is_sit_start?: boolean | null
          name?: string
          start_x?: number | null
          start_y?: number | null
          top_x?: number | null
          top_y?: number | null
          topo_path?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "climbs_boulder_id_fkey"
            columns: ["boulder_id"]
            isOneToOne: false
            referencedRelation: "boulders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "climbs_grade_id_fkey"
            columns: ["grade_id"]
            isOneToOne: false
            referencedRelation: "grades"
            referencedColumns: ["id"]
          },
        ]
      }
      grades: {
        Row: {
          font: string
          id: number
          value: number
        }
        Insert: {
          font: string
          id?: number
          value: number
        }
        Update: {
          font?: string
          id?: number
          value?: number
        }
        Relationships: []
      }
      sectors: {
        Row: {
          area_id: string
          id: string
          lat: number | null
          lon: number | null
          name: string
        }
        Insert: {
          area_id: string
          id?: string
          lat?: number | null
          lon?: number | null
          name: string
        }
        Update: {
          area_id?: string
          id?: string
          lat?: number | null
          lon?: number | null
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: "sectors_area_id_fkey"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
